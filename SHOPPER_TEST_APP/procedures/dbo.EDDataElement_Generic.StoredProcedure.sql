USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Generic]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDDataElement_Generic] @Parm1 char(5), @parm2 char(2), @parm3 char(15) As
select * from EDDataElement where Segment = @parm1 and Position = @parm2 and code like @parm3 order by Segment, Position, code
GO
