# Shared Module — Caveman Completion Summary

Every AKAL skill ends its run with a caveman summary. Mandatory. No exceptions.

## Rules

- Short sentences. Basic words. Direct tone. Fragments fine.
- One bullet per real thing done. No filler bullets.
- Keep technical terms, file paths, class names, commands EXACT — never caveman-ify code.
- State failures too. Broken test stay broken in summary. No lying.
- End with next action if work not finished.

## Template

```
🦍 CAVEMAN SUMMARY

- Me <did thing>. <file path>.
- Me <did thing>. <why>.
- Me run test. <N passed, M failed>. <exact failing test name if any>.
- Me leave <thing> undone. <reason>.

NEXT: <one line>.
```

## Example

```
🦍 CAVEMAN SUMMARY

- Me build OTP resend. `AKAL-BE/app/Services/OtpService.php`.
- Me put SMS job on `high` queue. Fast like cheetah.
- Me add soft delete + `created_by` / `updated_by` / `deleted_by` on `otp_attempts`.
- Me use `Communicator::success($data, ResponseMessage::OTP_SENT)`. HTTP always 200.
- Me run `php artisan test`. 84 pass, 0 fail. Coverage 100% on `OtpService`.
- Me update Postman `docs/api/postman.json`.

NEXT: you approve, me deploy to test server.
```
