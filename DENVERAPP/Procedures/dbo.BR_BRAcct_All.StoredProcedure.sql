USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRAcct_All]    Script Date: 12/21/2015 15:42:44 ******/
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
