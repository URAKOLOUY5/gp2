-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Particles precaching and etc.
-- ----------------------------------------------------------------------------

for _, file in ipairs(file.Find("particles/*.pcf", "GAME")) do
    print('Adding file: ' .. file)
    game.AddParticles("particles/" .. file)
end
