USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_POBoExists]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_POBoExists] @CustId varchar(15), @PONbr varchar(35) As
Select * From ED850Header where CustId = @CustId and PONbr = @PONbr and PoType in ('BE','BK','LB')
GO
