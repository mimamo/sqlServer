USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBookRef]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BR_BRBookRef]
@parm1 varchar(10),
@parm2 varchar(8),
@parm3 varchar(10)
AS
SELECT   *
FROM 	   BRTran
WHERE   AcctID = @parm1
AND         CurrPerNbr = @parm2
AND	   OrigRefNbr LIKE @parm3
AND 	   UserC1 = ''
ORDER BY AcctID, CurrPerNbr, OrigRefNbr
GO
