USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BI999_BR_Desc]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI999_BR_Desc]

AS

SELECT max(b.a4630) as 'b4630'
, max(b.a4631) as 'b4631'
, max(b.a4625) as 'b4625'
, max(b.a4645) as 'b4645'
, max(b.a4510) as 'b4510'
, max(b.a4600) as 'b4600'
, max(b.a4300) as 'b4300'
, max(b.a2303) as 'b2303'
, max(b.a4640) as 'b4640'
, max(b.a4255) as 'b4255'
, max(b.a1242) as 'b1242'
, max(b.FiscYr) as 'FiscYr'
FROM (
SELECT CASE WHEN RTRIM(a.acct) = '4630' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4630'
	  , CASE WHEN RTRIM(a.acct) = '4631' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4631'
	  , CASE WHEN RTRIM(a.acct) = '4625' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4625'
	  , CASE WHEN RTRIM(a.acct) = '4645' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4645'
	  , CASE WHEN RTRIM(a.acct) = '4510' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4510'
	  , CASE WHEN RTRIM(a.acct) = '4600' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4600'
	  , CASE WHEN RTRIM(a.acct) = '4300' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4300'
	  , CASE WHEN RTRIM(a.acct) = '2303' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a2303'
	  , CASE WHEN RTRIM(a.acct) = '4640' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4640'
	  , CASE WHEN RTRIM(a.acct) = '4255' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a4255'
	  , CASE WHEN RTRIM(a.acct) = '1242' 
			THEN RTRIM(a.acct) + ' - ' + a.descr end as 'a1242'
, Year(GetDate()) As 'FiscYr'
FROM account a
WHERE RTRIM(a.acct) in ('4630', '4631', '4625', '4645', '4510', '4600', '4300', '2303', '4640', '4255', '1242') 
) b
GO
