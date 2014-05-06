layouts =
{
    awful.layout.suit.tile,
}

--local greeks = { 'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω' }

tags = {}
for s = 1, screen.count() do
	if s == 1 then
		--tags[s] = awful.tag({'一', '二', '三', '四', '五', '六', '七', '八', '九'}, s, layouts[1])
		--tags[s] = awful.tag({'一', '二', '三', '四'}, s, layouts[1])
		--tags[s] = awful.tag({'!', '@', '#', '$'}, s, layouts[1])
		--tags[s] = awful.tag({'ク', 'ラ', 'ナ', 'ド'}, s, layouts[1])
		--tags[s] = awful.tag({'狼', '香', '辛', '料'}, s, layouts[1])
		--tags[s] = awful.tag({'k', 'a', 'w', 'a', 'i', 'i'}, s, layouts[1])
		tags[s] = awful.tag({'1', '2', '3', '4', '5', '6', '7', '8', '9'}, s, layouts[1])
		--tags[s] = awful.tag({'1', '2', '3', '4', '5/miru', '6/book', '7/know', '8/hack', '9/lang'}, s, layouts[1])
		--tags[s] = awful.tag({'一', '二', '三', '四', '五/miru', '六/book', '七/know', '八/hack', '九/lang'}, s, layouts[1])
        --tags[s] = awful.tag({'一', '二', '三', '四', heisig[math.random(1, #heisig-4)], heisig[math.random(1, #heisig-4)], heisig[math.random(1, #heisig-4)], heisig[math.random(1, #heisig-4)], heisig[math.random(1, #heisig-4)]}, s, layouts[1])
		--tags[s] = awful.tag({'私', 'は', 'あ', 'な', 'た', 'が', '好', 'き', 'だ'}, s, layouts[1])
		--tags[s] = awful.tag({'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix'}, s, layouts[1])
	else
		tags[s] = awful.tag({'1', '2', '3', '4', '5', '6', '7', '8', '9'}, s, layouts[1])
	end
end

--awful.layout.set(awful.layout.suit.fair, awful.tag.gettags(1)[1])
