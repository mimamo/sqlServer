USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMGBatch_10010_CpnyID]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DMGBatch_10010_CpnyID]
	@parm1 	varchar(10),
	@parm2 	varchar(10)

AS

       	Select * from Batch
	where 	CpnyID = @parm1
	  and	BatNbr like @parm2
          and 	((EditScrnNbr = '10010')
	  or 	(EditScrnNbr = '04010'
	  and	Batch.Module = 'PO'
	  and 	Status = 'C'
	  and 	BatNbr in (SELECT BatNbr from INTran where INTran.Rlsed = 0 and INTran.Jrnltype = 'PO' and INTran.CpnyID = Batch.CpnyID)))
        order by BatNbr, EditScrnNbr
GO
