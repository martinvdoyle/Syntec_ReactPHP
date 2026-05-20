import { Navigate, Route, Routes } from "react-router-dom";
import Layout from "./components/layout/Layout";
import ContactPage from "./pages/ContactPage";
import HomePage from "./pages/HomePage";
import MenuAdminPage from "./pages/MenuAdminPage";
import ProductsAdminPage from "./pages/ProductsAdminPage";
import ProductsPage from "./pages/ProductsPage";
import SuppliersPage from "./pages/SuppliersPage";

export default function App() {
  return (
    <Routes>
      <Route path="/admin/menu" element={<MenuAdminPage />} />
      <Route path="/admin/products" element={<ProductsAdminPage />} />
      <Route element={<Layout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/suppliers" element={<SuppliersPage />} />
        <Route path="/products" element={<ProductsPage />} />
        <Route path="/contact" element={<ContactPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}
