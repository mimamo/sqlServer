USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_INTran_TransferBat_LineID]    Script Date: 12/21/2015 14:17:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_INTran_TransferBat_LineID]
	@BatNbr 	varchar ( 10),
	@InitMode	smallint,
	@Status		varchar ( 1),
	@parm2beg 	smallint,
	@parm2end 	smallint
as

    	Select 	*
	from 	INTran
	where 	Batnbr = @BatNbr
	  and 	(@InitMode = 0 or Rlsed = 0 or @Status <> 'S')
       	  and 	LineNbr between @parm2beg and @parm2end
     	  and 	TranType = 'TR'
          and   ToSiteId <> ''
      	order by BatNbr, LineNbr
GO
