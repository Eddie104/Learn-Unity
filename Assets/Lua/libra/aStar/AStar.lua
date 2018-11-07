--
-- Author: Your Name
-- Date: 2017-12-11 21:22:29
--

-- The grid class
local Grid = require("libra.aStar.grid")
-- The pathfinder lass
local Pathfinder = require("libra.aStar.pathfinder")

local AStar = class("AStar")

function AStar:ctor(map, walkable)
	--[[
		finderName有以下选择
		'ASTAR'
        'DIJKSTRA' => Dijkstra(迪杰斯特拉)算法是典型的单源最短路径算法，
        			  用于计算一个节点到其他所有节点的最短路径。
        			  主要特点是以起始点为中心向外层层扩展，直到扩展到终点为止。
        			  Dijkstra算法是很有代表性的最短路径算法，
        			  在很多专业课程中都作为基本内容有详细的介绍，如数据结构，图论，运筹学等等。
        			  注意该算法要求图中不存在负权边。
        'THETASTAR' =》 Theta*算法。这种算法是A*的一种改进，
        				关键在于其打开一个节点s，然后更新周围的节点s'时，会检查s'与parent（s）的可见性。
        				theta-star 寻路算法 解决A*寻路的平滑问题
        'BFS' => Breadth First Search(BFS) 广度优先搜索
				 先访问的节点先扩展
				 每次扩展深度最浅的节点
				 可以用一个队列来保持待扩展的节点
        'DFS' =》 Depth First Search(DFS) 深度优先搜索
				 后被访问的节点先进行扩展
				 每次扩展深度最深的节点
				 对于无边界的搜索问题无法保证完备性
				 可以用一个栈来保持待扩展的节点
        'JPS' => Jump Point Search
        		 这是一个近年来发现的高效寻路算法。
        		 不过有一个限制就是只能在规则的网格地图上寻路，而且图上的点或边不能带权重，也就是不能有复杂的地形，只支持平坦和障碍两种地形
	]]
	--[[
	walkable 可以是一个数字，也可以是一个方法，返回值类型是Boolean
	]]
	self._myFinder = Pathfinder(Grid(map), 'THETASTAR', walkable)
end

function AStar:find(startX, startY, endX, endY, clearance)
	local path = self._myFinder:getPath(startX, startY, endX, endY, clearance)
	-- if path then
	-- 	-- print(('Path found! Length: %.2f'):format(path:getLength()))
	-- 	for node, count in path:nodes() do
	-- 		print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
	-- 	end
	-- end
	return path
end

function AStar:setWalkableAt(x, y, walkable)
	self._myFinder._grid:setWalkableAt(x, y, walkable)
end

function AStar:isWalkableAt(x, y, walkable, clearance)
	return self._myFinder._grid:isWalkableAt(x, y, walkable, clearance)
end

function AStar:getGrid()
	return self._myFinder._grid
end

function AStar:getFinder()
	return self._myFinder
end

return AStar
