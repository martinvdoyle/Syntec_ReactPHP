import { Navigate, Route, Routes } from "react-router-dom";
import Layout from "./components/layout/Layout";
import ErrorBoundary from "./components/ErrorBoundary";
import ContactPage from "./pages/ContactPage";
import HomePage from "./pages/HomePage";
import LookupAdminPage from "./pages/LookupAdminPage";
import MenuAdminPage from "./pages/MenuAdminPage";
import ProductsAdminPage from "./pages/ProductsAdminPage";
import ProductsPage from "./pages/ProductsPage";
import SuppliersAdminPage from "./pages/SuppliersAdminPage";
import SuppliersPage from "./pages/SuppliersPage";
import LanguagesAdminPage from "./pages/LanguagesAdminPage";

function NotFoundPage() {
  return (
    <main className="mx-auto max-w-[900px] p-6">
      <h1 className="text-2xl font-bold text-rose-700">Route not found</h1>
      <p className="mt-2 text-sm text-slate-700">The requested path does not match a configured route.</p>
    </main>
  );
}

export default function App() {
  return (
    <ErrorBoundary>
      <Routes>
        <Route path="/admin/menu" element={<MenuAdminPage />} />
        <Route path="/admin/products" element={<ProductsAdminPage />} />
        <Route path="/admin/suppliers" element={<SuppliersAdminPage />} />
        <Route path="/admin/discipline" element={<LookupAdminPage tableKey="discipline" />} />
        <Route path="/admin/product_group" element={<LookupAdminPage tableKey="product_group" />} />
        <Route path="/admin/product_type" element={<LookupAdminPage tableKey="product_type" />} />
        <Route path="/admin/divisions" element={<LookupAdminPage tableKey="divisions" />} />
        <Route path="/admin/job_titles" element={<LookupAdminPage tableKey="job_titles" />} />
        <Route path="/admin/message_enquiry_type" element={<LookupAdminPage tableKey="message_enquiry_type" />} />
        <Route path="/admin/message_types" element={<LookupAdminPage tableKey="message_types" />} />
        <Route path="/admin/sources" element={<LookupAdminPage tableKey="sources" />} />
        <Route path="/admin/users" element={<LookupAdminPage tableKey="users" />} />
        <Route path="/admin/messages" element={<LookupAdminPage tableKey="messages" />} />
        <Route path="/admin/languages" element={<LanguagesAdminPage />} />
        <Route element={<Layout />}>
          <Route path="/" element={<HomePage />} />
          <Route path="/suppliers" element={<SuppliersPage />} />
          <Route path="/products" element={<ProductsPage />} />
          <Route path="/contact" element={<ContactPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </ErrorBoundary>
  );
}
