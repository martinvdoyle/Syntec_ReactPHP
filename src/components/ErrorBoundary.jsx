import React from "react";

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch() {}

  render() {
    if (this.state.hasError) {
      return (
        <main className="mx-auto max-w-[1100px] p-6">
          <h1 className="text-2xl font-bold text-rose-700">Runtime error</h1>
          <pre className="mt-3 overflow-auto rounded border border-rose-200 bg-rose-50 p-3 text-xs text-rose-900">
            {String(this.state.error?.message || this.state.error || "Unknown error")}
          </pre>
        </main>
      );
    }
    return this.props.children;
  }
}

