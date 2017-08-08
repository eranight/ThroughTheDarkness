imagebytype =
{
	circle =
	{
		filename = "image/item_cir.png",
		bodytype = "radius",
		getradius = function( ceilsize )
			return 23 * ceilsize
		end
	},
	square =
	{
		filename = "image/item_sqr.png",
		bodytype = "shape",
		getshape = function( ceilsize )
			return { -23 * ceilsize, -23 * ceilsize, 23 * ceilsize, -23 * ceilsize, 23 * ceilsize, 23 * ceilsize, -23 * ceilsize, 23 * ceilsize }
		end
	},
	triangle =
	{
		filename = "image/item_trg.png",
		bodytype = "shape",
		getshape = function( ceilsize )
			return { 0 * ceilsize, -20 * ceilsize, 20 * ceilsize, 20 * ceilsize, -20 * ceilsize, 20 * ceilsize }
		end
	},
	star =
	{
		filename = "image/item_star.png",
		bodytype = "radius",
		getradius = function( ceilsize )
			return 10 * ceilsize
		end
	},
	heart =
	{
		filename = "image/item_heart.png",
		bodytype = "radius",
		getradius = function( ceilsize )
			return 15 * ceilsize
		end
	},
}