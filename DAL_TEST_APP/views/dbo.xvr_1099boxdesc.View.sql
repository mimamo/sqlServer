USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_1099boxdesc]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_1099boxdesc]
as
select '1' as boxnbrval, '1' as boxnbr1099, 'Rents' as boxdesc, 'CYBox00' as curraccthistfield, 'NYbox00' as nextaccthistfield
union all
select '2', '2', 'Royalties', 'CYBox01', 'NYBox01'
union all
select '3', '3', 'Other Income','CYBox02', 'NYBox02'
union all
select '4', '4', 'Federal Income Tax Withheld','CYBox03', 'NYBox03'
union all
select '5', '5', 'Fishing Boat Proceeds', 'CYBox04', 'NYBox04'
union all
select '6', '6', 'Medical and Health Care Payments', 'CYBox05', 'NYBox05'
union all
select '7', '7', 'Nonemployee Compensation', 'CYBox06', 'NYBox06'
union all
select '8', '8', 'Substiture payments in lieu of dividends or interest', 'CYBox07', 'NYBox07'
union all
select '10', '10', 'Crop Insurance Proceeds', 'CYBox09', 'NYBox09'
union all
select '13', '13', 'Excess golden parachute payments','s4future03', 's4future05'
union all
select '14', '14', 'Gross proceeds paid to an attorney', 's4future04', 's4future06'
union all
select '15', '15a', 'Section 409A deferrals', 'CYBox11', 'NYBox11'
union all
select '25', '15b', 'Section 409A income', 'CYBox12', 'NYBox12'
GO
