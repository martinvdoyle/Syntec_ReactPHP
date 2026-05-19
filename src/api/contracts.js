export const menuApiContract = {
  endpoint: "/menu.php",
  method: "GET",
  response: {
    menuKey: "main",
    items: [
      {
        id: 1,
        parentId: null,
        title: "Products",
        route: "/products",
        url: null,
        menuType: "mega",
        sortOrder: 10,
        visible: true,
        children: [],
      },
    ],
  },
};
