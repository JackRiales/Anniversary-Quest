return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 4,
  properties = {},
  tilesets = {
    {
      name = "Tiles",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../../assets/images/tilemaps/Tiles.png",
      imagewidth = 128,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 24,
      tiles = {
        {
          id = 0,
          probability = 0.5
        },
        {
          id = 6,
          probability = 0.5
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Terrain",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        9, 9, 1, 1, 9, 9, 15, 15, 15, 15, 1, 1, 9, 1, 1, 1,
        9, 9, 1, 9, 1, 9, 15, 15, 15, 15, 9, 1, 1, 9, 1, 9,
        1, 1, 17, 17, 17, 17, 15, 15, 15, 15, 17, 17, 17, 17, 1, 9,
        1, 9, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 1, 1,
        1, 9, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 1, 1,
        1, 9, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 9, 1,
        9, 9, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 9, 1,
        1, 9, 1, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 9, 9, 9,
        9, 9, 9, 9, 15, 15, 15, 15, 15, 15, 15, 15, 1, 1, 1, 1,
        1, 9, 1, 1, 1, 9, 1, 9, 1, 9, 9, 9, 9, 9, 1, 1,
        9, 1, 1, 1, 9, 9, 1, 1, 1, 9, 1, 9, 9, 9, 9, 1,
        1, 1, 9, 9, 1, 9, 9, 9, 1, 9, 9, 1, 9, 9, 1, 1,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19
      }
    },
    {
      type = "objectgroup",
      name = "Collision",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "Water",
          type = "Collider",
          shape = "rectangle",
          x = 0,
          y = 207.67,
          width = 255.333,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
