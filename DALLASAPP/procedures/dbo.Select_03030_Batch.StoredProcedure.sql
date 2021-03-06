USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Select_03030_Batch]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--- DCR added 5/6/98
--- DCR removed status = 'V' 12/17/98
Create Proc [dbo].[Select_03030_Batch] @parm1 varchar(10), @parm2 varchar ( 10) as
       Select * from Batch
           where CpnyID = @parm1
                 and ((EditScrnNbr = '03030' and status in ('B','C','H','P','S','U'))
				OR (EditScrnNbr = '03620'and status in ('C','P','U')))
             and module = 'AP'
		 and BatNbr like @parm2
           order by BatNbr
GO
