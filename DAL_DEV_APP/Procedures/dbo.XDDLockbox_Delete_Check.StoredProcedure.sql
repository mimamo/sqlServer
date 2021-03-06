USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLockbox_Delete_Check]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDLockbox_Delete_Check]
	@BatNbr		varchar( 10 )
as

	-- If this returns anything but zero, then there are good A/R Batches
	SELECT	count(*)
	FROM	XDDBatchARLB LB (nolock) LEFT OUTER JOIN Batch B (nolock)
		ON LB.PmtApplicBatNbr = B.BatNbr and B.Module = 'AR' and B.EditScrnNbr = '08030'
	WHERE	LB.LBBatNbr = @BatNbr
		and B.Status <> 'V'
GO
