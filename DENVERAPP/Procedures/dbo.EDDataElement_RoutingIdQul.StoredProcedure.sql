USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_RoutingIdQul]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_RoutingIdQul]  @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'TD' And Position = '502' And Code Like @Parm1
Order By Segment, Position, Code
GO
