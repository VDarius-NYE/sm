SM = {}
SM.Config = {}

-- Szerver alapbeállítások
SM.Config.ServerName = "SilverMilitary"
SM.Config.MaxPlayers = 64
SM.Config.DefaultSpawn = vector4(-1037.78, -2736.91, 20.17, 328.29) -- Fort Zancudo

-- Debuggolás
SM.Config.Debug = true

-- Adatbázis
SM.Config.Database = {
    UseOxMySQL = true
}

-- Játékos beállítások
SM.Config.Player = {
    StartingRank = 'recruit',
    StartingMoney = 0,
    SaveInterval = 5 * 60000 -- 5 perc (ms-ben)
}

-- Engedély szintek
SM.Config.Permissions = {
    ['user'] = 0,
    ['moderator'] = 1,
    ['admin'] = 2,
    ['superadmin'] = 3,
    ['owner'] = 4
}