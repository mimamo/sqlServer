USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_AllDMG]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDSTCustomer_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE Proc [dbo].[EDSTCustomer_AllDMG] @Parm1 varchar(15), @Parm2 varchar(10) As Select * From EDSTCustomer
Where CustId = @Parm1 And ShipToId Like @Parm2 Order By CustId, ShipToId
GO
