USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_INTran_BatNbr_LineID_KitAssembly]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_INTran_BatNbr_LineID_KitAssembly]
	@BatNbr 	varchar ( 10),
	@KitID		varchar ( 30),
	@RefNbr		varchar ( 15),
	@InitMode	smallint,
	@Status		varchar ( 1),
	@parm2beg 	smallint,
	@parm2end 	smallint
as

    	Select 	*
	from 	INTran
	where 	Batnbr = @BatNbr
	  and	InvtID <> @KitID
	  and	RefNbr = @RefNbr
	  and 	(@InitMode = 0 or Rlsed = 0 or @Status <> 'S')
       	  and 	LineNbr between @parm2beg and @parm2end
     	  and 	TranType not in ('CT', 'CG')
      	order by BatNbr, LineNbr
GO
