USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_All]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_All] @Parm1 varchar(10),@parm2 varchar(10)  As select * from Ed850Header  where cpnyid = @parm1 and EDIPoId like @parm2 order by EDIPOID
GO
