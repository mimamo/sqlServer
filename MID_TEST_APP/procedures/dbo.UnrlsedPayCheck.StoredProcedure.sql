USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[UnrlsedPayCheck]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[UnrlsedPayCheck] @Parm1 VarChar(10), @Parm2 VarChar(2), @Parm3 VarChar(15) As

Select
batnbr, refnbr
from ARTran where
SiteId = @Parm1 And
CostType = @Parm2 And
Custid = @Parm3 And
DRCR = "U" And
Trantype IN ("PA","CM","PP")
GO
