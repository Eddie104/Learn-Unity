local Body = class('Body', require('app.model.data.base.DisplayObject'))

function Body:ctor(parent, sortingOrder)
    Body.super.ctor(self)

    self._spriteRenderer.sortingLayerName = 'Role'
    self._spriteRenderer.sortingOrder = sortingOrder or 0
    self._transform = self._displayObject:GetComponent(typeof(Transform))
    self._transform:SetParent(parent)
end

function Body:updateSprite(data)
    self._transform.localPosition = data.vector2
    self._spriteRenderer.sprite = spritePool.get('test', 'role_001', data.name)
end

return Body