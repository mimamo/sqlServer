USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vr_40742_SOEvent]    Script Date: 12/21/2015 15:55:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vr_40742_SOEvent] as
select *, ShortAnswer00 = convert(char(10),'True') from SOEvent
GO
