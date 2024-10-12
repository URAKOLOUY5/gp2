-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Particles precaching and etc.
-- ----------------------------------------------------------------------------

for _, file in ipairs(file.Find("data_static/particles/*.pcf", "GAME")) do
    print('Adding file: ' .. file)
    game.AddParticles("data_static/particles/" .. file)
end
