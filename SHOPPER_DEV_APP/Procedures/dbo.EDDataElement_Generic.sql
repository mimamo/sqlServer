USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Generic]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDDataElement_Generic] @Parm1 char(5), @parm2 char(2), @parm3 char(15) As
select * from EDDataElement where Segment = @parm1 and Position = @parm2 and code like @parm3 order by Segment, Position, code
GO
