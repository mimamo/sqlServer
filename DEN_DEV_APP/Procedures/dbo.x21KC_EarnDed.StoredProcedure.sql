USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_EarnDed]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_EarnDed]  @parm1 varchar(10), @parm2 varchar(10), @parm3 varchar(4), @parm4 varchar(1), @parm5 varchar(6)   as      
select * from earnded where 
EarnDedID = @parm1 
and empid = @parm2 
and calyr = @parm3 and 
edtype = @parm4 
and wrklocid = @parm5 
order by earndedid
GO
