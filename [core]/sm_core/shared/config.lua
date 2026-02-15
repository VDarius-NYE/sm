if not SM then
    SM = {}
end

SM.Shared = {}

-- Rangok
SM.Shared.Ranks = {
    ['recruit'] = {
        label = 'Recruit',
        grade = 0,
        salary = 0
    },
    ['private'] = {
        label = 'Private',
        grade = 1,
        salary = 500
    },
    ['corporal'] = {
        label = 'Corporal',
        grade = 2,
        salary = 750
    },
    ['sergeant'] = {
        label = 'Sergeant',
        grade = 3,
        salary = 1000
    },
    ['lieutenant'] = {
        label = 'Lieutenant',
        grade = 4,
        salary = 1500
    },
    ['captain'] = {
        label = 'Captain',
        grade = 5,
        salary = 2000
    },
    ['major'] = {
        label = 'Major',
        grade = 6,
        salary = 2500
    },
    ['colonel'] = {
        label = 'Colonel',
        grade = 7,
        salary = 3000
    }
}

-- Csapatok
SM.Shared.Teams = {
    ['army'] = {
        label = 'Army',
        color = {r = 0, g = 150, b = 0},
        spawn = vector4(-1037.78, -2736.91, 20.17, 328.29)
    },
    ['rebels'] = {
        label = 'Rebels',
        color = {r = 150, g = 0, b = 0},
        spawn = vector4(1395.12, 3608.73, 38.94, 200.0)
    }
}