USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLB_sum_grp]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLB_sum_grp] @parm1 varchar (6), @parm2 varchar (10), @parm3 varchar(6) as
select
 sum(alloc_amount_ptd),
 sum(alloc_amount_ytd),
 sum(basis_amount_ptd),
 sum(basis_amount_ytd),
 grpid
from
 PJPOOLB
where
 period = @parm1 and
 alloc_cpnyid = @parm2 and
 grpid = @parm3
group by
 grpid
GO
