USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Location_QtyOnHand]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_QtyOnHand    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_QtyOnHand    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_QtyOnHand] as
        Select * from Location where QtyOnHand < 0.00
            order by QtyOnHand
GO
