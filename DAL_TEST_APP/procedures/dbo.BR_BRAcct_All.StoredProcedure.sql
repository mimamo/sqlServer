USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRAcct_All]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRAcct_All]
@parm1 varchar(10),
@parm2 varchar(10)
AS
Select *
from BRAcct
where cpnyid like @parm1 and AcctID like @parm2
order by AcctID
GO
