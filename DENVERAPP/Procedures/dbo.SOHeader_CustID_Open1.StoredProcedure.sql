USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_CustID_Open1]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[SOHeader_CustID_Open1] @parm1 varchar ( 15) as
          Select * from SOHeader where custid = @parm1
          and Status = "O"
          and UnshippedBalance > 0
          order by Ordnbr
GO
