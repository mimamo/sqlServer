USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_severy]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_severy]
as
        select * from PJPTDSUM
        order by project, pjt_entity, acct
GO
