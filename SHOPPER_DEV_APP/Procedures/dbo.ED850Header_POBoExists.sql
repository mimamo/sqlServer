USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_POBoExists]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_POBoExists] @CustId varchar(15), @PONbr varchar(35) As
Select * From ED850Header where CustId = @CustId and PONbr = @PONbr and PoType in ('BE','BK','LB')
GO
