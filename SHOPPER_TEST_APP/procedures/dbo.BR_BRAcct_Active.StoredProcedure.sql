USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRAcct_Active]    Script Date: 12/21/2015 16:06:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRAcct_Active] @parm1 varchar(10)
AS
Select *
from BRAcct
where Active = 1 and cpnyid = @parm1
order by cpnyId, AcctID
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Active = 'True'
GO
