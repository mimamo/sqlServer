USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_SegPos]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDDataElement_SegPos] @Segment varchar(5), @Position varchar(2), @Code varchar(15) As
Select * From EDDataElement Where Segment = @Segment And Position = @Position And Code Like @Code
Order By Segment, Position, Code
GO
