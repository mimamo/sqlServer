USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_severy]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_severy]
as
        select * from PJPTDSUM
        order by project, pjt_entity, acct
GO
