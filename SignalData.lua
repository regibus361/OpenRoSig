return {
	['AP01'] = {
		NextSignals = {},
		Block = 1,
		EnabledAspects = {
			false,
			false,
			true
		}
	},

	['AP02'] = {
		NextSignals = {},
		Block = 'AP003',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['AP03'] = {
		NextSignals = {'AP05'},
		Block = 1,
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP04'] = {
		NextSignals = {'AP02'},
		Block = 1,
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP05'] = {
		NextSignals = {'AP07'},
		Block = 'AP004',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP06'] = {
		NextSignals = {'AP04'},
		Block = 'AP005',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP07'] = {
		NextSignals = {'AP09'},
		Block = 'AP006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP08'] = {
		NextSignals = {'AP06'},
		Block = 'AP006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP09'] = {
		NextSignals = {'AP11'},
		Block = 'AP007',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP10'] = {
		NextSignals = {'AP08'},
		Block = 'AP008',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['AP11'] = {
		NextSignals = {'TN01'},
		Block = 'TN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN01'] = {
		NextSignals = {'CN09'},
		Block = 'CN003',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN02'] = {
		NextSignals = {'CN10'},
		Block = 'CN003',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN03'] = {
		NextSignals = {'TN23'},
		Block = 'CN002',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN04'] = {
		NextSignals = {'TN20'},
		Block = 'TN018',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN09'] = {
		NextSignals = {'CN15'},
		Block = 'CN007',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN10'] = {
		NextSignals = {'CN14', 'CN15'},
		Block = 'CN007',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN11'] = {
		NextSignals = {'CN03'},
		Block = 'CN004',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN12'] = {
		NextSignals = {'CN04'},
		Block = 'CN005',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN13'] = {
		NextSignals = {'CN15', 'CN16'},
		Block = 'CN007',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN14'] = {
		NextSignals = {},
		Block = 'CN006',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN15'] = {
		NextSignals = {'CN19'},
		Block = 'CN008',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN16'] = {
		NextSignals = {'CN20'},
		Block = 'CN009',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN17'] = {
		NextSignals = {'CN11', 'CN12', 'CN14'},
		Block = 'CN007',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN18'] = {
		NextSignals = {'CN14', 'CN12'},
		Block = 'CN007',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['CN19'] = {
		NextSignals = {'CN23'},
		Block = 'CN012',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN20'] = {
		NextSignals = {'CN24'},
		Block = 'CN013',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN21'] = {
		NextSignals = {'CN17'},
		Block = 'CN010',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN22'] = {
		NextSignals = {'CN18'},
		Block = 'CN011',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN23'] = {
		NextSignals = {'CN27', 'CN28'},
		Block = 'CN016',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN24'] = {
		NextSignals = {'CN27', 'CN28'},
		Block = 'CN016',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN25'] = {
		NextSignals = {'CN21'},
		Block = 'CN014',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN26'] = {
		NextSignals = {'CN22'},
		Block = 'CN015',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN27'] = {
		NextSignals = {'MF01'},
		Block = 'MF001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN28'] = {
		NextSignals = {'MF02'},
		Block = 'MF002',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN29'] = {
		NextSignals = {'CN25', 'CN26'},
		Block = 'CN017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN30'] = {
		NextSignals = {'CN25', 'CN26'},
		Block = 'CN017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN31'] = {
		NextSignals = {'CN25', 'CN26'},
		Block = 'CN017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['CN32'] = {
		NextSignals = {'CN27', 'CN28'},
		Block = 'CN016',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF01'] = {
		NextSignals = {'MF05'},
		Block = 'MF005',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF02'] = {
		NextSignals = {'MF06'},
		Block = 'MF006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF03'] = {
		NextSignals = {'CN29'},
		Block = 'MF003',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF04'] = {
		NextSignals = {'CN30'},
		Block = 'MF004',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF05'] = {
		NextSignals = {'MF09'},
		Block = 'MF009',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF06'] = {
		NextSignals = {'MF10'},
		Block = 'MF010',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF07'] = {
		NextSignals = {'MF03'},
		Block = 'MF007',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF08'] = {
		NextSignals = {'MF04'},
		Block = 'MF008',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF09'] = {
		NextSignals = {'MF13'},
		Block = 'MF013',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF10'] = {
		NextSignals = {'MF14'},
		Block = 'MF014',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF11'] = {
		NextSignals = {'MF07'},
		Block = 'MF011',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF12'] = {
		NextSignals = {'MF08'},
		Block = 'MF012',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF13'] = {
		NextSignals = {'MF17', 'MF18'},
		Block = 'MF017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF14'] = {
		NextSignals = {'MF18'},
		Block = 'MF017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF15'] = {
		NextSignals = {'MF11'},
		Block = 'MF015',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF16'] = {
		NextSignals = {'MF12'},
		Block = 'MF016',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF17'] = {
		NextSignals = {'MF21'},
		Block = 'MF018',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF18'] = {
		NextSignals = {'MF22'},
		Block = 'MF019',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF19'] = {
		NextSignals = {'MF15'},
		Block = 'MF017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF20'] = {
		NextSignals = {'MF15', 'MF16'},
		Block = 'MF017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF21'] = {
		NextSignals = {'MF25'},
		Block = 'MF022',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF22'] = {
		NextSignals = {'MF26'},
		Block = 'MF023',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF23'] = {
		NextSignals = {'MF19'},
		Block = 'MF020',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF24'] = {
		NextSignals = {'MF20'},
		Block = 'MF021',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF25'] = {
		NextSignals = {'MF29'},
		Block = 'MF026',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF26'] = {
		NextSignals = {'MF30'},
		Block = 'MF027',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF27'] = {
		NextSignals = {'MF23'},
		Block = 'MF024',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF28'] = {
		NextSignals = {'MF24'},
		Block = 'MF025',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF29'] = {
		NextSignals = {},
		Block = 'MF030',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['MF30'] = {
		NextSignals = {},
		Block = 'MF030',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['MF31'] = {
		NextSignals = {'MF27'},
		Block = 'MF028',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF32'] = {
		NextSignals = {'MF28'},
		Block = 'MF029',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF33'] = {
		NextSignals = {},
		Block = 'MF030',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF34'] = {
		NextSignals = {},
		Block = 'MF030',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['MF37'] = {
		NextSignals = {'MF15', 'MF16'},
		Block = 'MF017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN01'] = {
		NextSignals = {'RN04'},
		Block = 'RN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN02'] = {
		NextSignals = {'RN04'},
		Block = 'RN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN03'] = {
		NextSignals = {},
		Block = 'RN001',
		EnabledAspects = {
			true,
			false,
			false
		}
	},

	['RN04'] = {
		NextSignals = {'RN06'},
		Block = 'RN002',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN05'] = {
		NextSignals = {'RN03'},
		Block = 'RN003',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN06'] = {
		NextSignals = {'RN08'},
		Block = 'RN004',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN07'] = {
		NextSignals = {'RN05'},
		Block = 'RN005',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['RN08'] = {
		NextSignals = {'TN01', 'TN02'},
		Block = 'TN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN01'] = {
		NextSignals = {'TN05'},
		Block = 'TN002',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN02'] = {
		NextSignals = {'TN06'},
		Block = 'TN003',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN03'] = {
		NextSignals = {'RN07'},
		Block = 'TN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN04'] = {
		NextSignals = {'RN07', 'AP10'},
		Block = 'TN001',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN05'] = {
		NextSignals = {'TN09'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN06'] = {
		NextSignals = {'TN09', 'TN10'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN07'] = {
		NextSignals = {'TN03'},
		Block = 'TN004',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN08'] = {
		NextSignals = {'TN04'},
		Block = 'TN005',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN09'] = {
		NextSignals = {'TN13'},
		Block = 'TN007',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN10'] = {
		NextSignals = {'TN14'},
		Block = 'TN008',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN11'] = {
		NextSignals = {'TN07', 'TN08'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN12'] = {
		NextSignals = {'TN08'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN13'] = {
		NextSignals = {'TN17'},
		Block = 'TN011',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN14'] = {
		NextSignals = {'TN18'},
		Block = 'TN012',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN15'] = {
		NextSignals = {'TN11'},
		Block = 'TN009',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN16'] = {
		NextSignals = {'TN12'},
		Block = 'TN010',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN17'] = {
		NextSignals = {'TN21'},
		Block = 'TN015',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN18'] = {
		NextSignals = {'TN22'},
		Block = 'TN016',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN19'] = {
		NextSignals = {'TN15'},
		Block = 'TN013',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN20'] = {
		NextSignals = {'TN16'},
		Block = 'TN014',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN21'] = {
		NextSignals = {},
		Block = 'XX000',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN22'] = {
		NextSignals = {},
		Block = 'XX000',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN23'] = {
		NextSignals = {'TN19'},
		Block = 'TN017',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN24'] = {
		NextSignals = {'TN20'},
		Block = 'TN018',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN25'] = {
		NextSignals = {'TN01', 'TN02'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	},

	['TN26'] = {
		NextSignals = {'TN01', 'TN02'},
		Block = 'TN006',
		EnabledAspects = {
			true,
			true,
			true
		}
	}
}
