USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_cpnyid]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_cpnyid]  @siteid varchar(10), @cpnyid varchar(10) as      
select count(*) from site where
siteid = @siteid
and cpnyid <> @cpnyid
GO
