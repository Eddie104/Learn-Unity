local AnimationObject = class("AnimationObject", require("app.model.data.base.MapObject"))

function AnimationObject:ctor()
    AnimationObject.super.ctor(self)

    -- delay time
    self._dt = 0
    -- 当前帧的索引
    self._curFrame = 1
    -- 总帧数
    self._totalFrame = 0

    self._animationName = nil
    self._animationFrameArr = {}
    self._animationFrame = nil

    self._isPlaying = false
    -- 循环次数，0是无限循环
    self._loop = 0
    self._curLoop = 0
end

function AnimationObject:play(animationName, loop)
    if self._animationName ~= animationName then
        local success = false
        for i, v in ipairs(self._animationFrameArr) do
            if v.name == animationName then
                self._animationName = animationName
                self._animationFrame = v.frames
                self._curFrame = 0
                self._totalFrame = #self._animationFrame
                self._loop = loop or 0
                self._curLoop = 0
                self._isPlaying = true
                self:curFrame(1)
                success = true
                break
            end
        end
        return success
    end
end

function AnimationObject:onUpdate()
    if self._isPlaying then
        self._dt = self._dt + Time.deltaTime
        -- 200毫秒更换一帧
        if self._dt > 0.2 then
            self._dt = 0
            self:curFrame(self._curFrame + 1)
        end
    end
end

function AnimationObject:curFrame(val)
    if self._curFrame ~= val then
        local newFrame = self._curFrame
        if val <= self._totalFrame then
            newFrame = val
        elseif val == self._totalFrame + 1 then
            newFrame = 1
            if self._loop > 0 then
                self._curLoop = self._curLoop + 1
                if self._curLoop >= self._loop then
                    self._isPlaying = false
                end
            end
        end
        if newFrame ~= self._curFrame then
            self._curFrame = newFrame
            self:updateSprite()
        end
    end
end

function AnimationObject:updateSprite()
    -- body
    print(self._animationFrame[self._curFrame].name)
end

return AnimationObject