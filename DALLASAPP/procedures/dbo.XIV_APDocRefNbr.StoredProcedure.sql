USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_APDocRefNbr]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_APDocRefNbr] 
@parm1 smallint,
@parm2 VarChar(10) As
Select * from APDoc 
where DocClass = "N" and Rlsed >= @parm1 and Refnbr like @parm2
Order by Refnbr
GO
