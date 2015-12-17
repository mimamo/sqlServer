USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_GetDescr]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDDataElement_GetDescr] @Segment varchar(5), @Position varchar(2), @Code varchar(15) As
Select Description From EDDataElement Where Segment = @Segment And Position = @Position And Code = @Code
GO
