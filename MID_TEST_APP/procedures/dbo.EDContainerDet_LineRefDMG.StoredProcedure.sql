USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_LineRefDMG]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDContainerDet_LineRefDMG] @parm1 varchar(30),@parm2 varchar(5) as
Select * from edcontainerdet where invtid = @parm1  and  lineref like @parm2 order by lineref
GO
