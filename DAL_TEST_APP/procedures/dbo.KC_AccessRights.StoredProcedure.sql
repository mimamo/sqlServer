USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[KC_AccessRights]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KC_AccessRights] @userid varchar(47) as
select numrecs=count(*) from accessdetrights a
where (a.rectype = 'G' and a.userid = (select groupid from usergrp where userid = @userid) and a.screennumber = 'X21KC00')
or (a.rectype = 'U' and a.userid = @userid and a.screennumber = 'X21KC00')
GO
