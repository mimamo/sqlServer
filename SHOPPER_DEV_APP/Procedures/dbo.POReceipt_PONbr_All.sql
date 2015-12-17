USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_PONbr_All]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[POReceipt_PONbr_All] @parm1 varchar ( 10) As

select distinct po.*
from purchord po
inner join potran t on t.ponbr = po.ponbr
inner join poreceipt r on r.rcptnbr = t.rcptnbr
left join potran t2 on t2.rcptnbr = r.rcptnbr
where t2.ponbr  = @parm1
GO
