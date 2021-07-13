return {
	['S1'] = {
		NextSignals = {'S5'},
		Block = 'Main',
		EnabledAspects = {
			true,
			true,
			true
		}
	},
	
	['S2'] = {
		NextSignals = {'S5'},
		Block = 'Main',
		EnabledAspects = {
			true,
			true,
			true
		}
	},
	
	['S3'] = {
		NextSignals = {'S5'},
		Block = 'Main',
		EnabledAspects = {
			true,
			false,
			false
		}
	},
	
	['S4'] = {
		NextSignals = {},
		Block = 'Main',
		EnabledAspects = {
			true,
			false,
			false
		}
	},
	
	['S5'] = {
		NextSignals = {'S6'},
		Block = 'Outer1',
		EnabledAspects = {
			true,
			true,
			true
		}
	},
	
	['S6'] = {
		NextSignals = {'S3'},
		Block = 'Outer2',
		EnabledAspects = {
			true,
			true,
			true
		}
	},
}
