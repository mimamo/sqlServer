USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Get_PODate]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Get_PODate]
@parm1 varchar( 10 ),
@parm2 varchar( 10 )
as
select * from ED850HeaderExt where EDIPoId = @parm1 and CpnyId = @parm2
GO
