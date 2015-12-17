USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_AllDMG]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDDataElement_All    Script Date: 5/28/99 1:17:41 PM ******/
CREATE PROCEDURE [dbo].[EDDataElement_AllDMG] @parm1 varchar(5), @parm2 varchar(2), @parm3 varchar(15) AS
select * from EDDataElement
where Segment like @parm1
and Position Like @parm2
and code like @parm3
order by Segment, Position, code
GO
