USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValWorkLocDed_DedId_Delete]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValWorkLocDed_DedId_Delete] @parm1 varchar ( 10) as
           Delete ValWorkLocDed from ValWorkLocDed Where DedId = @parm1
GO
