USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRAcct]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_560_BRAcct]
AS
Select *
from BRAcct
where active = 1
order by AcctID
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Active = 'True'
GO
