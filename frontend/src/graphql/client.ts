import {
  ApolloClient,
  InMemoryCache,
  createHttpLink,
  from,
  CombinedGraphQLErrors,
} from "@apollo/client";
import { setContext } from "@apollo/client/link/context";
import { onError } from "@apollo/client/link/error";
import { useAuthStore } from "@/stores/auth_store";

const httpLink = createHttpLink({
  uri: import.meta.env.VITE_GRAPHQL_URL ?? "http://localhost:3000/graphql",
});

// Attach JWT from the auth store to every request
const authLink = setContext((_, prevContext: Record<string, unknown>) => {
  const token = useAuthStore.getState().token;
  const prevHeaders = (prevContext["headers"] ?? {}) as Record<string, string>;
  return {
    headers: {
      ...prevHeaders,
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  };
});

type NetworkErrorWithStatus = Error & { statusCode?: number };

// Clear auth state on 401-level errors; log GraphQL errors
const errorLink = onError(({ error }) => {
  if (CombinedGraphQLErrors.is(error)) {
    error.errors.forEach(({ message }) =>
      console.error("[GraphQL error]:", message)
    );
  } else {
    if ((error as NetworkErrorWithStatus).statusCode === 401) {
      useAuthStore.getState().clearAuth();
    }
    console.error("[Network error]:", error.message);
  }
});

const client = new ApolloClient({
  link: from([errorLink, authLink, httpLink]),
  cache: new InMemoryCache(),
});

export default client;
